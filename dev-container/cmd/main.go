package main


import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	userName string
	home string
)

func init() {
	userName = getUsername()
	home = os.Getenv("HOME")
}


// Container represents a dev container configuration
type Container struct {
	ImageName     string
	ContainerName string
	Hostname      string
	Volumes       []string
}

type runDockerRequest struct {
	WorkingDirectory string
	Command          []string
}

func (c Container) runDocker(req runDockerRequest) {

	args := []string{
		"run", "--rm", "-it",
		"-w", fmt.Sprintf("/home/%s/%s", username, req.WorkingDirectory),
		"--hostname", c.Hostname,
		"--name", c.ContainerName,
		"-v", fmt.Sprintf("%s:/home/%s/%s", req.WorkingDirectory, username, req.WorkingDirectory),
		"-v", fmt.Sprintf("%s/.zsh_other_env:/home/%s/.zsh_other_env", os.Getenv("HOME"), username),
		"-v", fmt.Sprintf("%s/.wakatime.cfg:/home/%s/.wakatime.cfg", os.Getenv("HOME"), username),
	}

	for _, volume := range c.Volumes {
		args = append(args, "-v", volume)
	}

	args = append(args, c.ImageName)
	args = append(args, req.Command...)

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

// ContainerFactory creates container configurations
type ContainerFactory interface {
	CreateContainer(wd string) Container
}

// PythonContainerFactory creates Python containers
type PythonContainerFactory struct{}

func (f PythonContainerFactory) CreateContainer(wd string) Container {
	return Container{
		ImageName:     "omegaatt36/python-dev:latest",
		ContainerName: "dev-python-" + wd,
		Hostname:      "dev-container-python",
	}
}

// NodeContainerFactory creates Node.js containers
type NodeContainerFactory struct{}

func (f NodeContainerFactory) CreateContainer(wd string) Container {
	return Container{
		ImageName:     "omegaatt36/node-dev:latest",
		ContainerName: "dev-node-" + wd,
		Hostname:      "dev-container-node",
		Volumes: []string{
			fmt.Sprintf("%s/.npmrc:/home/%s/.npmrc", wd, userName)
		},
	}
}

// JavaContainerFactory creates Java containers
type JavaContainerFactory struct{}

func (f JavaContainerFactory) CreateContainer(wd string) Container {
	return Container{
		ImageName:     "omegaatt36/java-dev:latest",
		ContainerName: "dev-java-" + wd,
		Hostname:      "dev-container-java",
	}
}

// getContainerFactory returns the appropriate factory for a language
func getContainerFactory(language string) (ContainerFactory, error) {
	switch language {
	case "python":
		return PythonContainerFactory{}, nil
	case "node":
		return NodeContainerFactory{}, nil
	case "java":
		return JavaContainerFactory{}, nil
	default:
		return nil, fmt.Errorf("unsupported language: %s", language)
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

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: run-dev <language> [optional command]")
		os.Exit(1)
	}

	language := os.Args[1]
	var command []string

	wd := filepath.Base(getWorkingDirectory())

	factory, err := getContainerFactory(language)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	container := factory.CreateContainer(wd)

	if len(os.Args) > 2 {
		command = os.Args[2:]
	}

	container.runDocker(runDockerRequest{
		WorkingDirectory: wd,
		Command:          command,
	})
}
