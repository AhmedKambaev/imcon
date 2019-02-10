module.exports = {
  presets: [
    [
      '@babel/preset-env',{ modules: false, "useBuiltIns": "entry", "debug": true}
    ],
    '@babel/preset-react',
  ],
  plugins: [
    'styled-components',
    "transform-function-bind",
    '@babel/plugin-syntax-dynamic-import',
    ["@babel/plugin-proposal-decorators", { "legacy": true }],
    ["@babel/plugin-proposal-class-properties", { "loose": true }]
  ],
  env: {
    production: {
      only: ['app'],
      plugins: [
        'lodash',
        'transform-react-remove-prop-types',
        '@babel/plugin-transform-react-inline-elements',
        '@babel/plugin-transform-react-constant-elements',
      ],
    },
    test: {
      plugins: [
        '@babel/plugin-transform-modules-commonjs',
        'dynamic-import-node',
      ],
    },
  },
};
