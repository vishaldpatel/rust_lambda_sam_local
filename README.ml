Goal:
- To get a basic AWS-Lambda function written in Rust running locally.

Prerequisites:
- Newer installation of Rust, probably.
- Updated Python installation with a working pip. You'll need this for installing an updated version of SAM Cli on MacOS. All other installation approaches seemed dated.

Useful Resoures:
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-mac.html
-- AWS SAM Reference for installing SAM CLI locally.

https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/
-- this will get you up and running a Rust function that is hosted on AWS Lambda.

Steps:

1. Install everything:
- Docker, SAM-cli, Rust

2. Start with a bare bones Rust project:
- mkdir my_test_dir
- cd my_test_dir
- cargo init

3. Setup your Rust project to compile to an AWS Lambda computer:
- Follow the "Compiling on Mac OS X" portion of the tutorial found here:
  https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/
  You should end up with a .cargo directory with a config file
  and a couple of entries in it.

4. Setup your Rust project to include the correct Lambda modules:
- Read the "Creating, Building, and Deploying a Rust Function" portion of
  https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/
  but only modify your Cargo.toml file. Also, it is a good idea to
  look up what each of the modules actually do, and perhaps include
  newer version of the modules for your project.

5. Add basic code to your main.rs file.
We now have the Rust project setup. We can try to compile it. Follow the "Building the Function" steps to create a rust.zip.

6. Tell SAM how to start a lambda function locally.
- touch template.yaml
- Add in information about your project, Runtime type, where SAM can find the code, and the API request that will execute the code.
- Something that you'll find intersting is that the "Runtime" setting is "provided", rather than "rust". Were we to follow the "Rust Runtime for AWS Lambda" tutorial, we'd be trying, like I did, to make all this work by setting the value of the "Runtime" property to "rust". As an exercise, you can try this tutorial with the "rust" setting to see how the system will behave differently.

7. Now that we have a Rust binary compiled and we've told SAM how to find it, lets fire up a local instance of lambda:
- sam local start-api -t ./template.yaml
Once it starts up, you can go to http://127.0.0.1:3000/ in your browser. Your first request will trigger the system to start downloading the docker image for lambdas that run a "provided" runtime. This can take a little while if you're, like me, working out of a coffee shop with a slow internet connection. When the download completes, the system will run your Rust binary to respond to the browser's request. You're all set! Barebones Rust lambda function running locally! =)

---

8. Once you're happy with your work, you'll probably want to deploy it to AWS. To do that, follow Steps #3 and #4 from here: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-quick-start.html
- Basically, you have to upload the zip file to an S3 bucket, and then update the create a second template.yaml where the code-url property is set to the address of the s3 bucket. You'd then run the 'sam deploy' command. Seems pretty straight forward, although I haven't tried it myself yet.
