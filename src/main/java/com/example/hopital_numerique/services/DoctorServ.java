package com.example.hopital_numerique.services;

import com.example.hopital_numerique.dao.daoInterfaces.*;
import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.services.serviceIntefaces.ISadmen;
import com.example.hopital_numerique.services.serviceIntefaces.ISdoctor;

import java.util.List;

import com.example.hopital_numerique.model.Status;


public class DoctorServ implements ISdoctor {

    Iconsultation consultationDao;
    ISadmen admenServ;

    public DoctorServ (Iconsultation consultationDao , ISadmen admenServ) {
        this.admenServ = admenServ;
        this.consultationDao = consultationDao;
    }
    @Override
    public List<Consultation> getDoctorConsultations(Doctor doctor) {
        if(doctor == null) {
            throw new IllegalArgumentException("Doctor cannot be null");
        }
        return consultationDao.findAll().stream().filter(consultation -> consultation.getDoctor().equals(doctor)).toList();
    }

    @Override
    public void validateConsultation(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        consultation.setStatus(Status.VALIDATED);
        consultationDao.update(consultation);

    }

    @Override
    public void refuseConsultation(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        consultation.setStatus(Status.REFUSED);
        consultationDao.update(consultation);

    }

    @Override
    public void addConsultationReport(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        if(consultation.getStatus() != Status.VALIDATED) {
            throw new IllegalArgumentException("Consultation must be validated before adding a report");
        }
        consultation.setStatus(Status.COMPLETED);
        consultationDao.update(consultation);

    }

    @Override
    public void updateConsultationReport(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        if(consultation.getStatus() != Status.COMPLETED) {
            throw new IllegalArgumentException("Consultation must be completed before updating a report");
        }
        consultationDao.update(consultation);

    }

    @Override
    public void updateConsultationStatus(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        consultationDao.update(consultation);

    }

    @Override
    public List<Consultation> getPendingAppointments(Doctor doctor) {
        if(doctor == null) {
            throw new IllegalArgumentException("Doctor cannot be null");
        }
        return consultationDao.findAll().stream().filter(consultation ->
                consultation.getDoctor().equals(doctor) && consultation.getStatus() == Status.PENDING).toList();
    }

    @Override
    public List<Consultation> getConsultationsByStatus(Consultation consultation, Doctor doctor) {
        if(consultation == null || doctor == null) {
            throw new IllegalArgumentException("Consultation and Doctor cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        return consultationDao.findByStatus(consultation.getStatus()).stream().filter(c ->
                c.getDoctor().equals(doctor)).toList();
    }
}
