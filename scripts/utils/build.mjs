import { resolve, basename } from 'path';
import { execSync } from 'child_process';
import jsonfile from "jsonfile";
import chalk from 'chalk';

function loadModels(folder) {
    const file = resolve(folder, 'models.json');

    try {
        return jsonfile.readFileSync(file);
    } catch (e) {
        console.log(chalk.red(`Unable to read ${file}`));
        console.log(e);
    }
}

function buildModel(scad_file, dest_file, options) {
    const opts = options.join(';');
    const command = `openscad -q -D "${opts}" -o "${dest_file}" "${scad_file}"`;
    let command_out;

    try {
        const command_opts = {
            stdio: 'pipe',
            stderr: 'stdio'
        };
        command_out = execSync(command, command_opts);
        //console.log(command);
    } catch (e) {
        console.log(`  ${chalk.red('✗')} Unable to render ${basename(scad_file)} to ${basename(dest_file)}`);
        console.error(`    ${e.stderr.toString().replace(/^\s+|\s+$/g, '')}`);
    }
}

function buildMultipartModel(name, model, src_folder, dest_folder, hasHollowBottom) {
    console.log(`${chalk.bold('Processing - ')}${name}`);
    model.parts.forEach(part => {
        let stl_filename = `${part}.stl`;
        let options = [`multiPartOutput=\\"${stl_filename}\\"`];
        let dest_file = resolve(dest_folder, stl_filename);
        const scad_file = resolve(src_folder, model.source);

        console.log(`  ${chalk.bold('• Rendering - ')}${stl_filename}`);
        buildModel(scad_file, dest_file, options);

        if (hasHollowBottom(part)) {
            stl_filename = `${part}_solid.stl`;
            dest_file = resolve(dest_folder, stl_filename);
            options.push('HOLLOW_BOTTOM=false');

            console.log(`  ${chalk.bold('• Rendering - ')}${stl_filename}`);
            buildModel(scad_file, dest_file, options);
        }
    });
}

function buildSinglepartModel(name, model, src_folder, dest_folder, hasHollowBottom) {
    console.log(`${chalk.bold('Processing - ')}${name}`);

    let stl_filename = `${name}.stl`;
    let options = [];
    let dest_file = resolve(dest_folder, stl_filename);
    const scad_file = resolve(src_folder, model.source);

    console.log(`  ${chalk.bold('• Rendering - ')}${stl_filename}`);
    buildModel(scad_file, dest_file, options);

    if (hasHollowBottom(name)) {
        stl_filename = `${name}_solid.stl`;
        dest_file = resolve(dest_folder, stl_filename);
        options.push('HOLLOW_BOTTOM=false');

        console.log(`  ${chalk.bold('• Rendering - ')}${stl_filename}`);
        buildModel(scad_file, dest_file, options);
    }
}

function checkHasHollowBottom(checklist, name) {
    return checklist.includes(name);
}

function buildModels(models, folder) {
    const dest_folder = resolve(folder, models.destdir);
    const hasHollowBottom = checkHasHollowBottom.bind(null, models.hollowbottom);

    Object.entries(models.multipart).forEach(([name, model]) => {
        buildMultipartModel(name, model, folder, dest_folder, hasHollowBottom)
    });

    Object.entries(models.singlepart).forEach(([name, model]) => {
        buildSinglepartModel(name, model, folder, dest_folder, hasHollowBottom);
    })
}

export function buildFolder(folder) {
    const models = loadModels(folder);
    buildModels(models, folder);
}