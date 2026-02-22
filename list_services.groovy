import org.moqui.context.ExecutionContext
ExecutionContext ec = context.ec
def services = ec.service.getKnownServiceNames()
println "Found ${services.size()} services"
services.findAll { it.startsWith("huddle") }.each { println it }
