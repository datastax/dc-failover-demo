package com.datastax.demo;

import io.dropwizard.Application;
import io.dropwizard.configuration.EnvironmentVariableSubstitutor;
import io.dropwizard.configuration.SubstitutingSourceProvider;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.datastax.demo.db.DemoDAO;
import com.datastax.demo.db.SchemaManager;
import com.datastax.demo.resources.DemoResource1;
import com.datastax.demo.resources.HealthCheckResource;
import com.datastax.demo.resources.HomeResource;
import com.datastax.oss.driver.api.core.CqlSession;

public class DemoServiceApplication extends Application<DemoServiceConfiguration> {
    private static final Logger logger = LoggerFactory.getLogger(DemoServiceApplication.class);

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
    public void run(final DemoServiceConfiguration config, final Environment environment) {
        final CqlSession session = config.getDriverFactory().build(environment);

        SchemaManager.createSchema(session, config);

        environment.jersey().register(new DemoResource1(new DemoDAO(session)));
        environment.jersey().register(new HealthCheckResource());
        environment.jersey().register(new HomeResource(environment.jersey().getResourceConfig()));
    }

}
