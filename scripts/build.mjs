import { Command, Argument } from 'commander'
import { readdir } from 'fs/promises';
import { dirname, resolve } from 'path';
import { fileURLToPath } from 'url';

import { buildFolder } from './utils/build.mjs';

const __filename = fileURLToPath(import.meta.url);
const rootPath = resolve(dirname(__filename), '..');

const getDirectories = async source =>
    (await readdir(source, { withFileTypes: true }))
        .filter(dirent => dirent.isDirectory())
        .filter(dirent => !dirent.name.startsWith('.'))
        .filter(dirent => dirent.name != 'scripts')
        .map(dirent => dirent.name);

const arg_folder = new Argument('<folder>', 'The folder to build')
    .choices(await getDirectories(rootPath));

const program = new Command();
program
      .addArgument(arg_folder);

program.parse();

buildFolder(program.args[0]);