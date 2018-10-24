exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
      "js/app.js": /^(js\/app|js\/socket)/,
      "js/index_controller.js": /^(js\/index_controller|js\/socket|node_modules)/,
      "js/monitor_controller.js": /^(js\/monitor_controller|js\/socket|node_modules)/
      }
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: /^(static)/
  },

  paths: {
    watched: ["static", "css", "js", "vendor"],
    public: "../priv/static"
  },

  plugins: {
    babel: {
      ignore: [/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/index_controller.js": ["js/index_controller"],
      "js/monitor_controller.js": ["js/monitor_controller"]
    }
  },

  npm: {
    enabled: true
  }
};
