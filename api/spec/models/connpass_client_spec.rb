# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConnpassClient, type: :model do
  let!(:stub_client) do
    stub_connection = Faraday.new do |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.request :url_encoded
      connection.response :mashify, mash_class: EventResponse
      connection.response :json
      connection.response :raise_error
      connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("event/?event_id=200") do |env|
          [200, {}, read_fixture_json("connpass_search_200.json")]
        end

        stub.get("event/?event_id=404") do |env|
          [404, {}, {}.to_json]
        end

        stub.get("event/?event_id=503") do |env|
          [503, {}, {}.to_json]
        end
      end
    end

    connpass_client = ConnpassClient.new
    allow(connpass_client).to receive(:connection).and_return(stub_connection)
    connpass_client
  end

  context "connpass config" do
    it "initialize" do
      expect(stub_client.class::API_ENDOPOINT).to eq "https://connpass.com/api/v1"
    end
  end

  context "connpass search" do
    it "200" do
      body = stub_client.search("200")
      events = body.events
      expect(events.count).to eq 1

      event = events.first
      expect(event.title).to eq "【オンライン開催】銀座Rails#30@リンクアンドモチベーション"
      expect(event.description).to eq "<h2>内容</h2>\n<p>銀座Railsは、Railsについての知識を交換し、日々の開発に役立てていこうという人々の集まるコミュニティです。</p>\n<h2>発表者募集</h2>\n\n<p>発表者を以下フォームにて募集しております。今回もオンライン開催のため、ご自宅等からのご登壇も歓迎です。</p>\n<p><a href=\"https://forms.gle/deEpxg2miZz8rgZX7\" rel=\"nofollow\">銀座Rails 登壇応募フォーム</a></p>\n<p>なおご登壇頂いた方には、銀座Rails Tシャツかパーカーのうちどれか一つ、お好きなものをプレゼント致します。\n<a href=\"https://suzuri.jp/ginzarails\" rel=\"nofollow\">https://suzuri.jp/ginzarails</a>\n※発送は銀座Rails実施後になります</p>\n<p>『こんな内容で大丈夫だろうか』『発表枠が長いので相談したい』などのご心配がありましたら、\nTwitter <a href=\"https://twitter.com/GinzaRails\" rel=\"nofollow\">@GinzaRails</a>までDM等でご相談下さい。\n(先着順のため、相談中の枠の完売につきましてはご容赦下さい)</p>\n<h2>タイムテーブル</h2>\n<table>\n<thead>\n<tr>\n<th>Time<img width=\"150\"></th>\n<th>Description</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>18:30</td>\n<td>開場</td>\n</tr>\n<tr>\n<td>19:00 -</td>\n<td>オープニング</td>\n</tr>\n<tr>\n<td>19:05 - 19:10</td>\n<td>スポンサーセッション リンクアンドモチベーションさま</td>\n</tr>\n<tr>\n<td>19:10 - 19:25</td>\n<td>森雅智(<a href=\"https://twitter.com/morimorihoge\" rel=\"nofollow\">@morimorihoge</a>)さん(BPS株式会社)「出張Railsウォッチ in 銀座Rails」</td>\n</tr>\n<tr>\n<td>19:25 - 19:40</td>\n<td>rince(<a href=\"https://twitter.com/kazumax1218\" rel=\"nofollow\">@kazumax1218</a>)さん「Railsで海外9ヵ国にサービス展開している話」<br>少数のエンジニアで海外複数ヵ国にサービス展開する上での工夫や、運用していく中でたまった設計・実装・テストにおける知見について発表します。</td>\n</tr>\n<tr>\n<td>19:40 - 20:15</td>\n<td>公募枠2</td>\n</tr>\n<tr>\n<td>20:15 - 20:25</td>\n<td>休憩 + バッファ</td>\n</tr>\n<tr>\n<td>20:25 - 20:30</td>\n<td>調整中</td>\n</tr>\n<tr>\n<td>20:30 - 21:00</td>\n<td>ゲストスピーカー<br>笹田 耕一(<a href=\"https://twitter.com/_ko1\" rel=\"nofollow\">@_ko1</a>)さん「Ruby 3.0 の Ractor について」<br>Ruby 3.0では、Ruby で簡単に並行並列プログラミングを行うためのRactorが導入されました。本発表では、Ractor の簡単な使い方と、現状と今後についてご紹介します。<br>参考文献: [<a href=\"https://techlife.cookpad.com/entry/2020/12/26/131858\" rel=\"nofollow\">Ruby 3.0 の Ractor を自慢したい - クックパッド開発者ブログ</a>]</td>\n</tr>\n<tr>\n<td>本編終了後</td>\n<td>オンライン懇親会</td>\n</tr>\n</tbody>\n</table>\n<p>※ 運営の都合により変更がある場合がございます。予めご了承下さい。</p>\n<h2>会場</h2>\n<p>ZOOMを用いたリモート開催となります。<br><br>\n<b>開場時間前後になりますと、本connpassにご登録されたアドレスに、参加のためのURLが配布されますので、そちらを用いてJoinをお願い致します。<br>\nno-reply@connpass.com からのメールが迷惑メールフォルダ等に入らないよう、ご注意下さい。 </b></p>\n<p>簡単なガイドが以下URL先にございますので、参加前にご一読下さい。<br>\n<a href=\"https://esa-pages.io/p/sharing/2231/posts/328/8522aec1b87aba9a2ad9.html\" rel=\"nofollow\">https://esa-pages.io/p/sharing/2231/posts/328/8522aec1b87aba9a2ad9.html</a></p>\n<p>その他、諸事項調整中です。運営に不慣れな点もございますが、ご協力をお願い致します 🙏</p>\n<h2>Sponsors</h2>\n<h3>スポンサー 株式会社ディー・エヌ・エー様</h3>\n<p><img alt=\"株式会社ディー・エヌ・エー様ロゴ\" src=\"https://ginzarails-public-images.s3-ap-northeast-1.amazonaws.com/DeNA_logo_RGB.png\" style=\"margin: 45px;\" width=\"80%\"></p>\n<h3>銀座スポンサー 株式会社リンクアンドモチベーション様</h3>\n<p><img alt=\"株式会社リンクアンドモチベーション様ロゴ\" src=\"https://ginzarails-public-images.s3-ap-northeast-1.amazonaws.com/lmi_logo.png\" style=\"margin: 45px;\" width=\"80%\"></p>"
      expect(event.started_at).to eq "2021-02-26T19:00:00+09:00"
      expect(event.ended_at).to eq "2021-02-26T21:00:00+09:00"
    end

    it "404" do
      expect {
        stub_client.search("404")
      }.to raise_error(Faraday::ResourceNotFound)
    end

    it "503" do
      expect {
        stub_client.search("503")
      }.to raise_error(Faraday::ServerError)
    end
  end

  def read_fixture_json(filename)
    File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
  end
end
