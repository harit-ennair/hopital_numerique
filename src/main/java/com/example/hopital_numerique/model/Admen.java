package com.example.hopital_numerique.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "admen")
@PrimaryKeyJoinColumn(name = "person_id")
public class Admen extends Person {

    private String name;

    public Admen(String firstName, String lastName, String email, String password, String role, String name) {
        super(firstName, lastName, email, password, role);
        this.name = name;
    }

    public Admen(String name) {
        this.name = name;
    }
    public Admen() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
