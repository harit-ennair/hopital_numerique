package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Person;

public interface Iperson {

    Person findByEmail(String email);
}
