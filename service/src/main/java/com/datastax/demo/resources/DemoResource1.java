package com.datastax.demo.resources;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.dropwizard.jersey.params.IntParam;

import com.datastax.demo.api.DemoEntity;
import com.datastax.demo.db.DemoDAO;

@Path("/demo")
@Produces(MediaType.APPLICATION_JSON)
public class DemoResource1
{

    private final DemoDAO demoDAO;

    public DemoResource1(DemoDAO demoDAO)
    {
        this.demoDAO = demoDAO;
    }

    @POST
    public DemoEntity create(DemoEntity entity)
    {
        return demoDAO.create(new DemoEntity(1, "post inserted"));
    }

    @GET
    @Path("{id}")
    public DemoEntity get(@PathParam("id") IntParam id)
    {
        return demoDAO.get(id.get());
    }
}

