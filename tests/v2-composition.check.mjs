import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const mainSource = await readFile(new URL('../src/main.js', import.meta.url), 'utf8');
const stylesSource = await readFile(new URL('../src/styles.css', import.meta.url), 'utf8');

assert.match(mainSource, /<main class="composition"/);
assert.match(mainSource, /<figure class="image-frame">/);
assert.match(mainSource, /src="\/this\.jpg"/);
assert.doesNotMatch(mainSource, /legacy\/public_html\/this\.jpg/);

assert.match(stylesSource, /min-height:\s*100vh/);
assert.match(stylesSource, /background:\s*#101010/i);
assert.match(stylesSource, /justify-content:\s*center/);
assert.match(stylesSource, /padding:\s*clamp\(8px,\s*2vw,\s*24px\)/);
assert.match(stylesSource, /transform:\s*translateY\(-2vh\)/);
assert.match(stylesSource, /\.image-frame img\s*\{[\s\S]*max-height:\s*min\(92vh,\s*1040px\)/);
assert.match(stylesSource, /@media\s*\(max-width:\s*720px\)\s*\{[\s\S]*\.composition\s*\{[\s\S]*padding:\s*0/);
assert.match(stylesSource, /@media\s*\(max-width:\s*720px\)\s*\{[\s\S]*\.image-frame img\s*\{[\s\S]*max-height:\s*100vh/);
assert.doesNotMatch(stylesSource, /border:\s*1px/);
assert.doesNotMatch(stylesSource, /box-shadow:\s*none/);
assert.doesNotMatch(stylesSource, /animation:\s*composition-enter/);
