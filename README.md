Jianxin Zhao:
Hi @ehirdoy, sorry that I can only provide a somewhat hacky instruction here, since at this stage
I think Actor code and doc may need some improvement before being automated. Ideally we only need
to start the manager and worker, maybe on different computer, and then run the code.
The steps here shows how I run a CNN example with Actor on one of my computer.

1. First, we should use the latest code from "lwae" branch in owlbarn/actor
2. Installation: make install
3. Suppose the source code is put at directory "foobar/actor", then hereafter we need to change working
   directory to "foobar/actor/_build/default/test"
4. Open one terminal, running command actor_manager; then open, say, 2 terminals, on each one run actor_worker.
5. In this directory you should find an executable "test_owl_parallel.exe". Open another terminal, and run this
   executable with any word as parameter. For example: "./test_owl_parallel.exe hello". Note that we should change
   another word if we want to run this executable again. Also, this example is actually a CIFAR example, but a
   MNIST one should be very similar.
6. Now check the output of the other terminals. Things should be going well now, with each worker executing
   training of network. Three things to note: 1) the loss decrease quite slow, 2) the training actually won't
   stop since the [stop condition](https://github.com/owlbarn/owl/blob/master/src/owl/neural/owl_neural_parallel.ml#L153)
   is not yet implemented, and 3) some error information about socket is raised during training. I'm still looking
   at these issues. So that is some personal experience about how I run a CNN example with Actor on my computer.

Please feel free to correct me if there is a better/correct practice on different machines.
I'm glad to discuss some other hacks I might forgot to mention here, but a better way is surely to fix the code,
doc, and examples of Actor soon. I'm interested to discuss about how you guys use Actor while I'm also learning
and trying to improve it :

# OCaml Distributed Data Processing

A distributed data processing system developed in OCaml

# Todo

How to express arbitrary DAG? How to express loop? Apply function.

Interface to Irmin or HDFS to provide persistent storage

Test delay-bounded and error-bounded barrier

Split Context module into server and client two modules

Implement parameter.mli

Implement barrier control in parameter modules

Rename ... DataContext and ModelContext?

Implement Coordinate Descent in model parallel ...

Enhance Mapreduce engine, incorporate with owl.

Add techreport based on the barrier control.


# How to compile & run it?

To compile and build the system, you do not have to install all the software yourself. You can simply pull a ready-made container to set up development environment.

```bash
docker pull ryanrhymes/actor
```

Then you can start the container by

```bash
docker run -t -i ryanrhymes/actor:latest /bin/bash
```

After the container starts, go to the home director, clone the git repository.

```bash
git clone https://github.com/ryanrhymes/actor.git
```

Then you can compile and build the system.

```bash
make oasis && make
```
