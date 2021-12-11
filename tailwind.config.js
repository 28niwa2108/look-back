module.exports = {
  purge: ["app/views/*/*.erb", "app/views/*/*/*.erb","app/javascript/delete_alert.js"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      width: {
        '400px': '400px'
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}