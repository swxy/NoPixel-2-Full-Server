const webpack = require("webpack");

module.exports = {
  entry: "./src/server/server.ts",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/
      }
    ]
  },
  plugins: [new webpack.DefinePlugin({ "global.GENTLY": false })],
  optimization: {
    minimize: true
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"]
  },
  output: {
    filename: "server.js",
    path: __dirname + "/dist/"
  },
  target: "node"
};
