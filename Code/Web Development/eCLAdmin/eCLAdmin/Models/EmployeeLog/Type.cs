﻿namespace eCLAdmin.Models.EmployeeLog
{
    public class Type
    {
        public int Id { get; set; }
        public string Description { get; set; }

        public Type() { }
        public Type(int id, string description)
        {
            Id = id;
            Description = description;
        }
    }
}