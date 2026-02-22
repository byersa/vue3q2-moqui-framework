try {
    def result = ec.service.sync().name("huddle.HuddleServices.get#HuddleDiscussionTree").parameters([workEffortId:"WE_DemoHuddle"]).call()
    println "Service result: " + result
} catch (Exception e) {
    println "Error: " + e.getMessage()
    e.printStackTrace()
}
