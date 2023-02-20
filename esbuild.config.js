const path = require('path')
const rails = require('esbuild-rails')

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  minify: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript/*.*")
}).catch(() => process.exit(1))