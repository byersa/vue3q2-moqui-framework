import org.moqui.context.ExecutionContext
ExecutionContext ec = context.ec
def serviceName = "huddle.HuddleServices.get#HuddleDiscussionTree"
def serviceDef = ec.service.getServiceDefinition(serviceName)
if (serviceDef) {
    println "Service FOUND: " + serviceName
    println "Location: " + serviceDef.serviceNode.attribute("location")
} else {
    println "Service NOT FOUND: " + serviceName
    def allServices = ec.service.getKnownServiceNames()
    def huddleServices = allServices.findAll { it.contains("huddle") }
    println "Known 'huddle' services: " + huddleServices
}
