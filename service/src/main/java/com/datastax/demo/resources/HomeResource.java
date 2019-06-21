package com.datastax.demo.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Instant;

import io.dropwizard.jersey.DropwizardResourceConfig;

@Path("/")
public class HomeResource
{
    private final DropwizardResourceConfig resourceConfig;

    public HomeResource(DropwizardResourceConfig resourceConfig) {
        this.resourceConfig = resourceConfig;
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String get() throws UnknownHostException
    {
        String paths = resourceConfig.getEndpointsInfo();
        String privateIP = InetAddress.getLocalHost().getHostAddress();

        return String.format("Welcome to the demo! \n\n%s\n\nResponded from: %s\n%s", Instant.now(), privateIP, paths);
    }
}
