package com.datastax.demo.resources;

import com.datastax.demo.api.CartItem;
import com.datastax.demo.db.ShoppingDAO;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/cart")
@Produces(MediaType.APPLICATION_JSON)
public class ShoppingResource {
    private final ShoppingDAO shoppingDAO;

    public ShoppingResource(ShoppingDAO shoppingDAO) {
        this.shoppingDAO = shoppingDAO;
    }

    @POST
    @Path("{username}/add")
    public void addItemToCart(@PathParam("username") String username, CartItem item) {
        shoppingDAO.addItem(username, item);
    }

    @GET
    @Path("{username}")
    public Iterable<CartItem> getCart(@PathParam("username") String username) {
        return shoppingDAO.getCart(username);
    }
}
