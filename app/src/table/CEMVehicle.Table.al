table 6086337 "CEM Vehicle"
{
    Caption = 'Vehicle';
    DataCaptionFields = "Code";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; Default; Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            var
                Vehicle: Record "CEM Vehicle";
            begin
                Vehicle.SetRange(Default, true);
                Vehicle.SetFilter(Code, '<>%1', Code);
                if not Vehicle.IsEmpty then
                    Error(OneDefaultErr, Vehicle.TableCaption);
            end;
        }
        field(11; "Company Car"; Boolean)
        {
            Caption = 'Company Car';
        }
        field(12; Image; Text[30])
        {
            Caption = 'Image';
            TableRelation = "CEM Image".Description;
        }
        field(13; "No. of Company Policies"; Integer)
        {
            CalcFormula = Count("CEM Company Policy" WHERE("Document Type" = CONST(Expense),
                                                            "Document Account No." = FIELD(Code)));
            Caption = 'No. of Company Policies';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ExpPostingSetup: Record "CEM Posting Setup";
    begin
        ExpPostingSetup.SetRange(Type, ExpPostingSetup.Type::Mileage);
        ExpPostingSetup.SetRange("No.", Code);
        ExpPostingSetup.DeleteAll(true);
    end;

    var
        OneDefaultErr: Label 'There can only be one default %1.';
        VehicleCodeMissingErr: Label 'You must set up a %1 for %2 = %3 in ''%4'' or configure a %1 with %5 = %6.';


    procedure GetUserVehicle(User: Code[50]): Code[20]
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DefaultUserSetup: Record "CEM Default User Setup";
        Vehicle: Record "CEM Vehicle";
    begin
        if DefaultUserSetup.Get(DefaultUserSetup."Setup Type"::User, User) then
            if DefaultUserSetup."Vehicle Code" <> '' then
                exit(DefaultUserSetup."Vehicle Code");

        if ContiniaUserSetup.Get(User) then
            if ContiniaUserSetup."Expense User Group" <> '' then
                if DefaultUserSetup.Get(DefaultUserSetup."Setup Type"::Group, ContiniaUserSetup."Expense User Group") then
                    if DefaultUserSetup."Vehicle Code" <> '' then
                        exit(DefaultUserSetup."Vehicle Code");

        Vehicle.SetRange(Default, true);
        if not Vehicle.FindFirst then
            Error(VehicleCodeMissingErr, Vehicle.TableCaption, ContiniaUserSetup.FieldCaption("Continia User ID"), User,
              DefaultUserSetup.TableCaption, Vehicle.FieldCaption(Default), true);

        exit(Vehicle.Code);
    end;


    procedure HasBeenUsedWithinAYear(): Boolean
    var
        Mileage: Record "CEM Mileage";
    begin
        Mileage.SetCurrentKey("Continia User ID", "Registration Date", "Vehicle Code");
        Mileage.SetRange("Registration Date", Today - 365, Today);
        Mileage.SetRange("Vehicle Code", Rec.Code);
        exit(not Mileage.IsEmpty);
    end;
}

