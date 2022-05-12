// eslint-disable-next-line camelcase
import child_process from "child_process";

/**
 * Start judge service and restart it when connection lost.
 *
 * Exit code = 100 means connection lost.
 */

// eslint-disable-next-line no-constant-condition
while (true) {
    // eslint-disable-next-line camelcase
    const child = child_process.fork("./src/index");

    child.on("error", (error) => {
        // eslint-disable-next-line no-console
        console.error(error);
        child.kill("SIGKILL");
        process.exit(-1);
    });

    await new Promise((resolve) => {
        // eslint-disable-next-line consistent-return
        child.on("exit", (code) => {
            // 100: Disconnected
            if (code === 100) {
                // Restart child
                return resolve();
            }

            process.exit(code);
        });
    });
}
