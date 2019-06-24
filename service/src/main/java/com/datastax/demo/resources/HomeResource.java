package com.datastax.demo.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Instant;
import java.util.stream.Collectors;

import io.dropwizard.jersey.DropwizardResourceConfig;

import com.datastax.oss.driver.api.core.CqlSession;

@Path("/")
public class HomeResource
{
    private final DropwizardResourceConfig resourceConfig;
    private final CqlSession session;

    public HomeResource(DropwizardResourceConfig resourceConfig, CqlSession session) {
        this.resourceConfig = resourceConfig;
        this.session = session;
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String get() throws UnknownHostException
    {
        final String paths = resourceConfig.getEndpointsInfo();
        final String privateIP = InetAddress.getLocalHost().getHostAddress();

        final StringBuilder builder = new StringBuilder(256);
        builder
            .append("Welcome to the demo! \n\n")
            .append(Instant.now())
            .append("\n\n")
            .append("HTTP responded from: ")
            .append(privateIP)
            .append("\n\nConnected to: ")
            .append(session.getMetadata().getNodes().values().stream()
                .filter(n -> n.getOpenConnections() > 0)
                .map(n -> n.getListenAddress().get().getAddress().getHostAddress())
                .collect(Collectors.joining(", ")))
            .append("\n\n")
            .append(paths);

        return builder.toString();
    }
}
