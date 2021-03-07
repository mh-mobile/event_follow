import Event from "./Event"

export default {
  title: "Event",
  component: Event,
  parameters: {
    layout: "centered"
  }
}

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Event },
  template: `<Event v-bind="$props" /> `
})

export const Default = Template.bind({})
Default.args = {
  eventInfo: {
    event: {
      id: 1822,
      site_id: 1,
      site_event_id: 204014,
      title: "Flutter × Kotlin Multiplatform by CyberAgent #2",
      started_at: "2021-02-24T10:00:00.000Z",
      ended_at: "2021-02-24T12:00:00.000Z",
      banner:
        "https://connpass-tokyo.s3.amazonaws.com/thumbs/7d/f5/7df5d3d912651e96ccb586374fb8a120.png",
      url: "https://cyberagent.connpass.com/event/204014/",
      description:
        '\u003ch1\u003e概要\u003c/h1\u003e\n\u003cp\u003eサイバーエージェントメディア事業部では、スピード感をもって品質の高い実装を行うために、少人数でアプリ開発を行うことを念頭に置きクロスプラットフォームフレームワークの導入を進めております。\u003c/p\u003e\n\u003cp\u003e今回は Flutter、Kotlin Multiplatform を中心に開発の中でのTipsをお話しします。\u003cbr\u003e\u003c/p\u003e\n\u003cp\u003eオンライン開催となりますので、ご興味ある方是非お気軽にご応募下さい。\u003cbr\u003e\n※後半はzoom懇親会もご用意しております。\u003c/p\u003e\n\u003cul\u003e\n\u003cli\u003e開催日：2021年2月24日（水）19:00 ZOOM 開放 19:15スタート\u003c/li\u003e\n\u003cli\u003e場所：オンライン（ZOOM）\u003c/li\u003e\n\u003cli\u003e参加費：無料\u003c/li\u003e\n\u003c/ul\u003e\n\u003ch1\u003eZOOMに関して\u003c/h1\u003e\n\u003cp\u003e参加者宛に、後日参加のための URL を連絡しますので、 connpass からのメールを受信できる状態にしてください。なお、 URL の SNS などへのシェアはお控えいただきますようお願いいたします。\u003c/p\u003e\n\u003cp\u003e本勉強会は \u003cstrong\u003eZoomミーティングのみでの開催\u003c/strong\u003e です。YouTube Live等へのストリーミングは行いません。参加には \u003cstrong\u003eZoomアカウントが必須\u003c/strong\u003e となりますので、Zoomアカウントをお持ちでない方は当日までにアカウント登録を行ってください。\u003c/p\u003e\n\u003ch1\u003e注意事項\u003c/h1\u003e\n\u003cul\u003e\n\u003cli\u003e技術交流が目的の勉強会ですので、知識の共有および、参加者同士の交流を目的としない参加はお断りしています。\u003c/li\u003e\n\u003cli\u003e参加目的が不適切だと判断される場合には、運営側で参加をキャンセルさせていただく場合がございます。\u003c/li\u003e\n\u003cli\u003eイベント開催中に上記に該当する不適切な参加者であると判断できた場合は、 ZOOM への接続を無効化させて頂く場合がございます。\u003c/li\u003e\n\u003c/ul\u003e\n\u003ch1\u003e登壇者\u003c/h1\u003e\n\u003ch4\u003eShun Sato, 株式会社タップル\u003c/h4\u003e\n\u003cp\u003e\u003cimg src="https://static.wixstatic.com/media/877259_f5a5c68ec7704632b941110d3a7fe9b0~mv2.png" width="128px"\u003e\n\u003c/p\u003e\u003cp\u003e\n\u003cb\u003eGitHub:  \u003ca href="https://github.com/satoshun" rel="nofollow"\u003esatoshun\u003c/a\u003e  Twitter: \u003ca href="https://twitter.com/stsn_jp" rel="nofollow"\u003estsn_jp\u003c/a\u003e\u003c/b\u003e\n\u003c/p\u003e\u003cdiv\u003eタップルのAndroidアプリを開発しています。世界平和を願いながら生きています。\u003c/div\u003e\n\u003cp\u003e\u003c/p\u003e\u003cp\u003e\u003c/p\u003e\n\u003ch4\u003eKentaro Kawakami, 株式会社CyberArrow\u003c/h4\u003e\n\u003cp\u003e\u003cimg src="https://qiita-image-store.s3.amazonaws.com/0/98075/profile-images/1533198771" width="128px"\u003e\n\u003c/p\u003e\u003cp\u003e\n\u003cb\u003eGitHub:  \u003ca href="https://github.com/Keeeeen" rel="nofollow"\u003eKeeeeen\u003c/a\u003e  Twitter: \u003ca href="https://twitter.com/knschwarze" rel="nofollow"\u003eKnschwarze\u003c/a\u003e\u003c/b\u003e\n\u003c/p\u003e\u003cdiv\u003e新規事業をFlutterで開発しています。FRESHLIVE、CLのiOSアプリを開発していました\u003c/div\u003e\n\u003cp\u003e\u003c/p\u003e\u003cp\u003e\u003c/p\u003e\n\u003ch4\u003eTaiki Suzuki, 株式会社AbemaTV\u003c/h4\u003e\n\u003cp\u003e\u003cimg src="https://pbs.twimg.com/profile_images/672766169846181888/3mptLVlk_400x400.jpg" width="128px"\u003e\n\u003c/p\u003e\u003cp\u003e\n\u003cb\u003eGitHub:  \u003ca href="https://github.com/marty-suzuki" rel="nofollow"\u003emarty-suzuki\u003c/a\u003e  Twitter: \u003ca href="https://twitter.com/marty_suzuki" rel="nofollow"\u003emarty_suzuki\u003c/a\u003e\u003c/b\u003e\n\u003c/p\u003e\u003cdiv\u003eABEMAのiOSアプリ開発を担当しています。最近は既存プロジェクトにKMMを導入するための調査や暫定的に導入してみたりをしています。\u003c/div\u003e\n\u003cp\u003e\u003c/p\u003e\u003cp\u003e\u003c/p\u003e\n\u003ch1\u003eタイムテーブル\u003c/h1\u003e\n\u003cp\u003e※ 発表内容が決まり次第、順次更新していきます。\u003c/p\u003e\n\u003ctable\u003e\n\u003cthead\u003e\n\u003ctr\u003e\n\u003cth\u003e時間\u003c/th\u003e\n\u003cth\u003e\u003c/th\u003e\n\u003c/tr\u003e\n\u003c/thead\u003e\n\u003ctbody\u003e\n\u003ctr\u003e\n\u003ctd\u003e19:00\u003c/td\u003e\n\u003ctd\u003e受付開始\u003c/td\u003e\n\u003c/tr\u003e\n\u003ctr\u003e\n\u003ctd\u003e19:15 - 19:30\u003c/td\u003e\n\u003ctd\u003eイベント趣旨/会社説明\u003c/td\u003e\n\u003c/tr\u003e\n\u003ctr\u003e\n\u003ctd\u003e19:30 - 20:30\u003c/td\u003e\n\u003ctd\u003e『　(仮)KMMの並行処理とメモリ管理　』 20分\u003cbr\u003eShun Sato\u003cbr\u003e\u003cbr\u003e 『 (仮)Flutterで動画再生したい 』20分\u003cbr\u003eKentaro Kawakami\u003cbr\u003e\u003cbr\u003e 『 (仮)iOSにKMMを導入するtips 』20分\u003cbr\u003eTaiki Suzuki\u003c/td\u003e\n\u003c/tr\u003e\n\u003ctr\u003e\n\u003ctd\u003e20:30 - 21:00\u003c/td\u003e\n\u003ctd\u003eオンライン懇親会\u003c/td\u003e\n\u003c/tr\u003e\n\u003c/tbody\u003e\n\u003c/table\u003e\n\u003cp\u003e※ 適宜休憩を取ります。\u003cbr\u003e\n※ 当日予告なく時間配分、内容が変更になる可能性がございます。\u003c/p\u003e\n\u003ch1\u003e個人情報の取扱いについて\u003c/h1\u003e\n\u003cp\u003e主催：株式会社サイバーエージェント\u003c/p\u003e\n\u003cp\u003e申し込み時にご提供いただいた情報は、イベント受付管理や各種ご案内（サービス・イベント等）に利用させていただきます。\u003c/p\u003e'
    },
    extra: { user_ids: "79753638", friends_number: 1 }
  }
}
