package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: run-dev <language> [optional command]")
		os.Exit(1)
	}

	language := os.Args[1]
	var imageName string
	var containerName string
	var hostname string
	var command []string

	wd := filepath.Base(getWorkingDirectory())

	switch language {
	case "python":
		imageName = "omegaatt36/python-dev:latest"
		containerName = "dev-python-" + wd
		hostname = "dev-container-python"
	case "node":
		imageName = "omegaatt36/node-dev:latest"
		containerName = "dev-node-" + wd
		hostname = "dev-container-node"
	case "java":
		imageName = "omegaatt36/java-dev:latest"
		containerName = "dev-java-" + wd
		hostname = "dev-container-java"
	default:
		fmt.Println("Unsupported language:", language)
		os.Exit(1)
	}

	if len(os.Args) > 2 {
		command = os.Args[2:]
	}

	runDocker(imageName, containerName, hostname, wd, command)
}

func runDocker(imageName, containerName, hostname, wd string, command []string) {
	username := getUsername()

	args := []string{
		"run", "--rm", "-it",
		"-w", fmt.Sprintf("/home/%s/%s", username, wd),
		"--hostname", hostname,
		"-v", fmt.Sprintf("%s:/home/%s/%s", wd, username, wd),
		"-v", fmt.Sprintf("%s:/home/%s/.zsh_other_env", fmt.Sprintf("%s/.zsh_other_env", os.Getenv("HOME")), username),
		"-v", fmt.Sprintf("%s:/home/%s/.wakatime.cfg", fmt.Sprintf("%s/.wakatime.cfg", os.Getenv("HOME")), username),
		"--name", containerName,
		imageName,
	}

	args = append(args, command...)

	// fmt.Println("Running Docker command:", strings.Join(args, " "))
	cmd := exec.Command("docker", args...)
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		fmt.Println("Error running docker command:", err)
		os.Exit(1)
	}
}

func getUsername() string {
	out, err := exec.Command("whoami").Output()
	if err != nil {
		fmt.Println("Error getting username:", err)
		os.Exit(1)
	}
	return strings.TrimSpace(string(out))
}

func getWorkingDirectory() string {
	out, err := exec.Command("pwd").Output()
	if err != nil {
		fmt.Println("Error getting working directory:", err)
		os.Exit(1)
	}
	return strings.TrimSpace(string(out))
}
