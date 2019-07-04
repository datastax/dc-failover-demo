package com.datastax.demo;

import com.datastax.demo.db.DemoDAO;
import com.datastax.demo.db.SchemaManager;
import com.datastax.demo.db.ShoppingDAO;
import com.datastax.demo.resources.DemoResource1;
import com.datastax.demo.resources.HealthCheckResource;
import com.datastax.demo.resources.HomeResource;
import com.datastax.demo.resources.ShoppingResource;
import com.datastax.oss.driver.api.core.CqlSession;
import io.dropwizard.Application;
import io.dropwizard.configuration.EnvironmentVariableSubstitutor;
import io.dropwizard.configuration.SubstitutingSourceProvider;
import io.dropwizard.jersey.errors.ErrorMessage;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import java.io.PrintWriter;
import java.io.StringWriter;

public class DemoServiceApplication extends Application<DemoServiceConfiguration> {
    private static final Logger logger = LoggerFactory.getLogger(DemoServiceApplication.class);

    private static class DemoExceptionMapper implements ExceptionMapper<Exception> {
        @Override
        public Response toResponse(Exception e) {
            StringWriter stackTraceWriter = new StringWriter();
            e.printStackTrace(new PrintWriter(stackTraceWriter));
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorMessage(e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }
    }

    public static void main(final String[] args) throws Exception {
        new DemoServiceApplication().run(args);
    }

    @Override
    public String getName() {
        return "DemoService";
    }

    @Override
    public void initialize(final Bootstrap<DemoServiceConfiguration> bootstrap) {
        bootstrap.setConfigurationSourceProvider(
            new SubstitutingSourceProvider(bootstrap.getConfigurationSourceProvider(),
                new EnvironmentVariableSubstitutor(false)));
    }

    @Override
    public void run(final DemoServiceConfiguration config, final Environment environment) throws InterruptedException {
        final CqlSession session = config.getDriverFactory().build(environment);

        if (config.getDriverFactory().isCreateSchema()) {
            SchemaManager.createSchema(session, config);
        } else {
            SchemaManager.waitSchema(session);
        }

        environment.jersey().register(new DemoExceptionMapper());
        environment.jersey().register(new DemoResource1(new DemoDAO(session)));
        environment.jersey().register(new ShoppingResource(new ShoppingDAO(session)));
        environment.jersey().register(new HealthCheckResource());
        environment.jersey().register(new HomeResource(environment.jersey().getResourceConfig(), session));
    }

}
