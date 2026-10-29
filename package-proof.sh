set -eu
export PATH=/opt/nodes/node-v26.13.0-linux-x64/bin:/usr/local/bin:/usr/bin:/bin
node /evidence/verify-tree.mjs
node /evidence/package-manifest.mjs package-after-restore.json
node --input-type=module -e 'import fs from "node:fs";import assert from "node:assert/strict";const before=JSON.parse(fs.readFileSync("/evidence/package-before-restore.json"));const after=JSON.parse(fs.readFileSync("/evidence/package-after-restore.json"));assert.deepEqual(after,before);fs.writeFileSync("/evidence/PACKAGE_CANONICAL_EQUALITY.json",JSON.stringify({files:after.length,identical:true},null,2));console.log("All",after.length,"package files byte-identical after canonical rebuild");'
mkdir -p /consumer
cd /consumer
printf '{"private":true,"type":"module"}\n' > package.json
npm pack /work/pkgs/core/dist/date-fns --json > /evidence/npm-pack.json
filename=$(node -e 'process.stdout.write(JSON.parse(require("node:fs").readFileSync("/evidence/npm-pack.json"))[0].filename)')
npm install --no-audit --no-fund "./$filename"
cp /evidence/installed-package-proof.mjs ./proof.mjs
node proof.mjs
node /evidence/verify-tree.mjs
