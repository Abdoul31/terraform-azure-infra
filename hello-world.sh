mkdir hello-world
cd hello-world
curl https://start.spring.io/starter.zip \
  -d dependencies=web \
  -d name=HelloApp \
  -d packageName=com.example.hello \
  -d type=war \
  -o hello-world.zip

unzip hello-world.zip -d .
