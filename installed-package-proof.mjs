import assert from 'node:assert/strict';
import fs from 'node:fs';
import {createRequire} from 'node:module';
import {parseISO as esmRoot} from 'date-fns';
import {parseISO as esmSubpath} from 'date-fns/parseISO';
import {parseISO as esmFP} from 'date-fns/fp';
import {parseISOWithOptions} from 'date-fns/fp/parseISOWithOptions';
const require=createRequire(import.meta.url);
const cjsRoot=require('date-fns').parseISO;
const cjsSubpath=require('date-fns/parseISO').parseISO;
const cjsFP=require('date-fns/fp').parseISO;
const sourceFiles=['/evidence/timestamp-records.jsonl','/evidence/actual-dotnet-record.jsonl'];
const records=sourceFiles.flatMap(file=>fs.readFileSync(file,'utf8').trim().split(/\r?\n/).map(line=>JSON.parse(line.replace(/^\uFEFF/,''))));
let assertions=0;
for (const [entry,parse] of Object.entries({esmRoot,esmSubpath,esmFP,cjsRoot,cjsSubpath,cjsFP})) {
 for(const record of records){assert.equal(parse(record.value).toISOString(),record.expected,`${entry}: ${record.source}`);assertions++;}
}
class ContextDate extends Date{}
for(const record of records){
 const contextual=esmSubpath(record.value,{in:value=>new ContextDate(value)});
 assert(contextual instanceof ContextDate);assert.equal(contextual.toISOString(),record.expected);assertions+=2;
 const fpContextual=parseISOWithOptions({in:value=>new ContextDate(value)})(record.value);
 assert(fpContextual instanceof ContextDate);assert.equal(fpContextual.toISOString(),record.expected);assertions+=2;
}
const result={assertions,records:records.length,version:require('date-fns/package.json').version,esmURL:import.meta.resolve('date-fns/parseISO'),cjsPath:require.resolve('date-fns/parseISO'),sourceFiles};
fs.writeFileSync('/evidence/installed-package-proof.json',JSON.stringify(result,null,2));console.log(JSON.stringify(result,null,2));
