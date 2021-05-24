const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const coffee =  require('./loaders/coffee')
const erb =  require('./loaders/erb')

environment.loaders.prepend('erb', erb)
environment.loaders.prepend('coffee', coffee)
module.exports = environment

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    Moment: 'moment'
  })
)