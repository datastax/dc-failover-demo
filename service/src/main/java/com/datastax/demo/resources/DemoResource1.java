package com.datastax.demo.resources;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import io.dropwizard.jersey.errors.ErrorMessage;
import io.dropwizard.jersey.params.IntParam;

import com.datastax.demo.api.DemoEntity;
import com.datastax.demo.db.DemoDAO;

@Path("/demo")
@Produces(MediaType.APPLICATION_JSON)
public class DemoResource1
{

    private final DemoDAO demoDAO;

    private Response errorMessage(Response.Status status, String message)
    {
        return Response.status(status)
                .entity(new ErrorMessage(status.getStatusCode(), message))
                .build();
    }

    public DemoResource1(DemoDAO demoDAO)
    {
        this.demoDAO = demoDAO;
    }

    @POST
    public DemoEntity create(DemoEntity entity)
    {
        return demoDAO.create(new DemoEntity(entity.getId(), entity.getContent()));
    }

    @GET
    @Path("{id}")
    public Response get(@PathParam("id") IntParam id )
    {
        DemoEntity entity = demoDAO.get(id.get());
        if (entity == null)
        {
            return errorMessage(Response.Status.NOT_FOUND, "Unable to find demo entity for ID");
        }
        return Response.ok(entity).build();
    }

}

