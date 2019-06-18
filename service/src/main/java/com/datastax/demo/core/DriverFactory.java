package com.datastax.demo.core;

import java.net.InetSocketAddress;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.dropwizard.lifecycle.Managed;
import io.dropwizard.setup.Environment;
import org.hibernate.validator.constraints.NotEmpty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.CqlSessionBuilder;
import com.datastax.oss.driver.api.core.session.Session;

public class DriverFactory
{
    private static final Logger logger = LoggerFactory.getLogger(DriverFactory.class);
    private static final int PORT = 9042;

    @NotEmpty
    private String contactPoints;

    @NotEmpty
    private String localDataCenter;

    @JsonProperty
    public String getLocalDataCenter() {
        return localDataCenter;
    }

    @JsonProperty
    public void setLocalDataCenter(String localDataCenter) {
        this.localDataCenter = localDataCenter;
    }

    @JsonProperty
    public String getContactPoints() {
        return contactPoints;
    }


    @JsonProperty
    public void setContactPoints(String contactPoints) {
        this.contactPoints = contactPoints;
    }

    public Session build(Environment environment) {
        final CqlSessionBuilder builder = CqlSession.builder();

        for (String contactPoint : contactPoints.split("\\s*,\\s*")) {
            builder.addContactPoint(new InetSocketAddress(contactPoint, PORT));
        }

        final Session session = builder.withLocalDatacenter(localDataCenter).build();
        environment.lifecycle().manage(new Managed() {
            @Override
            public void start() {
            }

            @Override
            public void stop() {
                session.close();
            }
        });

        return session;
    }
}
