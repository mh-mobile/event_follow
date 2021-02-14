const path = require('path')

module.exports = {
  stories: ['../components/**/*.stories.js'],
  addons: [
      {
        name: '@storybook/addon-essentials',
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
  webpackFinal: config => {
    config.module.rules.push({
      test: /\.scss$/,
      use: ['style-loader', 'css-loader', 'sass-loader'],
      include: path.resolve(__dirname, '../')
    })
    return config
  }
}
