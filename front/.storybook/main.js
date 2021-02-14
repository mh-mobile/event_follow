const path = require("path")

module.exports = {
  stories: ["../components/**/*.stories.ts"],
  addons: [
    {
      name: "@storybook/addon-essentials",
      options: {
        actions: true,
        backgrounds: true,
        controls: true,
        docs: true,
        viewport: true,
        toolbars: true
      }
    }
  ],
  webpackFinal: (config) => {
    config.module.rules.push({
      test: /\.scss$/,
      use: ["style-loader", "css-loader", "sass-loader"],
      include: path.resolve(__dirname, "../")
    })

    config.module.rules.push(
      {
        test: /\.pug$/,
        use: [
          { loader: 'pug-plain-loader' }
        ]
      }
    );
    config.resolve.alias["@"] = path.resolve(__dirname, "..")
    return config
  }
}
