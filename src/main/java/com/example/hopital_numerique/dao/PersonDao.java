package com.example.hopital_numerique.dao;

import com.example.hopital_numerique.dao.daoInterfaces.Iperson;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Person;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class PersonDao implements Iperson {

    @Override
    public Person findByEmail(String email) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
        EntityManager em = emf.createEntityManager();
        try {
        Person person = em.createQuery("SELECT p FROM Person p WHERE p.email = :email", Person.class)
                .setParameter("email", email)
                .getSingleResult();
        return person;
        }catch (Exception e) {
            return null;
        }finally {
            em.close();
            emf.close();
        }

    }
}
