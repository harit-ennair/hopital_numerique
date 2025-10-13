package com.example.hopital_numerique.services;

import com.example.hopital_numerique.dao.daoInterfaces.*;
import com.example.hopital_numerique.model.Consultation;
import com.example.hopital_numerique.model.Doctor;
import com.example.hopital_numerique.model.Patient;
import com.example.hopital_numerique.model.Status;
import com.example.hopital_numerique.services.serviceIntefaces.ISpatien;

import java.util.List;

public class PatienServ implements ISpatien {

    Idepartment departmentDao;
    Idoctor doctorDao;
    Iroom roomDao;
    Iconsultation consultationDao;
    Ipatient patientDao;

    public PatienServ (Idepartment departmentDao , Idoctor doctorDao , Iroom roomDao , Iconsultation consultationDao , Ipatient patientDao) {
        this.patientDao = patientDao;
        this.roomDao = roomDao;
        this.departmentDao = departmentDao;
        this.doctorDao = doctorDao;
        this.consultationDao = consultationDao;
    }


    @Override
    public Consultation bookAppointment(Patient patient, Doctor doctor, Consultation consultation) {
        if(patient == null || doctor == null || consultation == null) {
            throw new IllegalArgumentException("Patient, Doctor and Consultation cannot be null");
        }
        if(!consultation.getDoctor().equals(doctor)) {
            throw new IllegalArgumentException("Doctor is not assigned to this consultation");
        }
        consultation.setPatient(patient);
        consultation.setStatus(Status.PENDING);
        consultationDao.save(consultation);
        return consultation;
    }

    @Override
    public void cancelAppointment(Patient patient, Consultation consultation) {
        if(patient == null || consultation == null) {
            throw new IllegalArgumentException("Patient and Consultation cannot be null");
        }
        if(!consultation.getPatient().equals(patient)) {
            throw new IllegalArgumentException("Patient is not assigned to this consultation");
        }
        consultation.setStatus(Status.CANCELED);
        consultationDao.update(consultation);

    }

    @Override
    public Consultation modifyAppointment(Patient patient, Consultation consultation) {
        if(patient == null || consultation == null) {
            throw new IllegalArgumentException("Patient and Consultation cannot be null");
        }
        if(!consultation.getPatient().equals(patient)) {
            throw new IllegalArgumentException("Patient is not assigned to this consultation");
        }
        consultationDao.update(consultation);
        return consultation;
    }

    @Override
    public List<Consultation> getConsultationHistory(Patient patient) {
        if(patient == null) {
            throw new IllegalArgumentException("Patient cannot be null");
        }
        return consultationDao.findAll().stream().filter(consultation -> consultation.getPatient().equals(patient)).toList();
    }
}
