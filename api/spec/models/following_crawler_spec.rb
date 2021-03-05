# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowingCrawler, type: :model do
  describe "find_target_user" do
    let(:tomo_user_token) do
      FactoryBot.create(:tomo_user_token)
    end

    let(:satoshi_user_token) do
      FactoryBot.create(:satoshi_user_token)
    end

    let(:jiro_user_token) do
      FactoryBot.create(:jiro_user_token)
    end

    context "ターゲットユーザーがDBに存在しない場合" do
      it "ターゲットユーザーが見つからない" do
        target_user = FollowingCrawler.new.find_target_user
        expect(target_user).to eq nil
      end
    end

    context "ターゲットユーザーがDBに存在する場合(following_last_updated_atありのユーザーを含まない)" do
      it "ターゲットユーザーが見つかる" do
        tomo_user_token
        target_user = FollowingCrawler.new.find_target_user
        expect(target_user).not_to eq nil
        expect(target_user.name).to eq "tomo"
      end
    end

    context "ターゲットユーザーがDBに存在する場合(following_last_updated_atありのユーザーを含む)" do
      it "ターゲットユーザーが見つかる" do
        tomo_user_token
        jiro_user_token
        target_user = FollowingCrawler.new.find_target_user
        expect(target_user).not_to eq nil
        expect(target_user.name).to eq "tomo"
      end

      it "ターゲットユーザーが見つかる" do
        jiro_user_token
        target_user = FollowingCrawler.new.find_target_user
        expect(target_user).not_to eq nil
        expect(target_user.name).to eq "jiro"
      end
    end
  end

  describe "フォロー情報の取得" do
    let!(:stub_client) do
      stub_connection = Faraday.new do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
        connection.response :raise_error
        connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("friends/list.json") do |env|
            count = env.params["count"]
            if count == "0"
              [200, {}, read_fixture_json("friends_list_empty_results.json")]
            elsif count == "1"
              [200, {}, read_fixture_json("friends_list_next_cursor_0.json")]
            else
              [200, {}, read_fixture_json("friends_list_next_cursor_1522334438265527337.json")]
            end
          end
        end
      end

      twitter_client = TwitterClient.new(
        app_token: "test_app_token",
        oauth_consumer_key: "test_oauth_consumer_key",
        oauth_token: "test_oauth_token",
        oauth_consumer_secret: "test_oauth_consumer_secret",
        oauth_token_secret: "test_oauth_token_secret"
      )
      allow(twitter_client).to receive(:connection).and_return(stub_connection)
      twitter_client
    end

    context "ユーザーがヒットしない場合" do
      let!(:tomo_user_token) do
        FactoryBot.create(:tomo_user_token)
      end

      let(:tomo) do
        FactoryBot.build(:tomo)
      end

      let(:search_following) do
        response = stub_client.following(count: "0")
        [response.users, response.next_cursor_str]
      end

      before do
        allow_any_instance_of(FollowingCrawler).to receive(:search_following).and_return(search_following)
      end

      it "ユーザー情報は取得されない" do
        tomo.reload
        expect(tomo.following_next_cursor).to eq "-1"
        expect(tomo.following_last_updated_at).to eq nil
        expect { FollowingCrawler.new.execute }.not_to change { User.count }
        tomo.reload
        expect(tomo.following_next_cursor).to eq "-1"
        expect(tomo.following_last_updated_at).not_to eq nil
      end
    end

    context "ユーザーを取得した場合(next_cursorなし)" do
      let!(:tomo_user_token) do
        FactoryBot.create(:tomo_user_token)
      end

      let(:tomo) do
        FactoryBot.build(:tomo)
      end

      let(:search_following) do
        response = stub_client.following(count: "1")
        [response.users, response.next_cursor_str]
      end

      before do
        allow_any_instance_of(FollowingCrawler).to receive(:search_following).and_return(search_following)
      end

      it "ユーザー情報は取得される" do
        tomo.reload
        expect(tomo.following_next_cursor).to eq "-1"
        expect(tomo.following_last_updated_at).to eq nil
        expect { FollowingCrawler.new.execute }.to change { [User.count, Friendship.count] }.from([1, 0]).to([3, 2])
        tomo.reload
        expect(tomo.following_next_cursor).to eq "-1"
        expect(tomo.following_last_updated_at).not_to eq nil
      end
    end

    context "ユーザーを取得した場合(next_cursorあり)" do
      let!(:tomo_user_token) do
        FactoryBot.create(:tomo_user_token)
      end

      let!(:jiro_user_token) do
        FactoryBot.create(:jiro_user_token)
      end

      let(:tomo) do
        FactoryBot.build(:tomo)
      end

      let!(:jiro) do
        FactoryBot.build(:jiro)
      end

      let(:search_following) do
        response = stub_client.following(count: "2")
        [response.users, response.next_cursor_str]
      end

      before do
        allow_any_instance_of(FollowingCrawler).to receive(:search_following).and_return(search_following)
      end

      it "ユーザー情報は取得される" do
        tomo.reload
        expect(tomo.following_next_cursor).to eq "-1"
        expect(tomo.following_last_updated_at).to eq nil
        expect { FollowingCrawler.new.execute }.to change { [User.count, Friendship.count] }.from([2, 0]).to([4, 3])
        tomo.reload
        jiro.reload
        expect(tomo.following_next_cursor).to eq "1522334438265527337"
        expect(tomo.following_last_updated_at).not_to eq nil
        expect(jiro.name).to eq "name_jiro_update"
        expect(jiro.screen_name).to eq "screen_name_jiro_update"
        expect(jiro.screen_name).to eq "screen_name_jiro_update"
      end
    end
  end
end
