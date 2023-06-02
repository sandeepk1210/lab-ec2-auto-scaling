var aws = require("aws-sdk");
exports.handler = (event, context, callback) => {
  console.log("LogAutoScalingEvent");
  console.log("Received event:", JSON.stringify(event, null, 2));
  var autoscaling = new aws.AutoScaling({ region: event.region });
  var eventDetail = event.detail;
  var params = {
    AutoScalingGroupName: eventDetail["web-dev-asg"] /* required */,
    LifecycleActionResult: "CONTINUE" /* required */,
    LifecycleHookName: eventDetail["autoscaling_lifecycle_hook"] /* required */,
    InstanceId: eventDetail["EC2InstanceId"],
    LifecycleActionToken: eventDetail["LifecycleActionToken"],
  };
  var response;
  autoscaling.completeLifecycleAction(params, function (err, data) {
    if (err) {
      console.log(err, err.stack); // an error occurred
      response = {
        statusCode: 500,
        body: JSON.stringify("ERROR"),
      };
    } else {
      console.log(data); // successful response
      response = {
        statusCode: 200,
        body: JSON.stringify("SUCCESS"),
      };
    }
  });
  return response;
};
