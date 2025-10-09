package com.example.hopital_numerique.dao.daoInterfaces;

import com.example.hopital_numerique.model.Admen;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Patient;

import java.util.List;

public interface Iadmen {
    void save(Admen admen);
    void update(Admen admen);
    void delete(int admenId);
    Admen findById(int admenId);
    List<Admen> findAll();

}
