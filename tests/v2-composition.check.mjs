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
assert.doesNotMatch(stylesSource, /animation:\s*composition-enter/);
