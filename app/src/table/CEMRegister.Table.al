table 6086367 "CEM Register"
{
    Caption = 'Register';
    LookupPageID = "CEM Mileage Register";
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "No. of Mileage Entries"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Register No." = FIELD("No.")));
            Caption = 'No. of Mileage Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownMileageEntries;
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = Count("CEM Mileage" WHERE("Reimbursement Register No." = FIELD("No.")));
            Caption = 'No. of Reimbursed Mileage Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownReimbEntries;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CreateRegEntry(): Integer
    var
        EMReg: Record "CEM Register";
    begin
        EMReg.LockTable;
        if EMReg.FindLast then
            EMReg."No." := EMReg."No." + 1
        else
            EMReg."No." := 1;
        EMReg.Init;
        EMReg."Creation Date" := Today;
        EMReg."User ID" := UserId;
        EMReg.Insert;
        exit(EMReg."No.");
    end;


    procedure DrillDownMileageEntries()
    var
        Mileage: Record "CEM Mileage";
        PostedMileage: Page "CEM Posted Mileage";
    begin
        Mileage.SetCurrentKey("Register No.");
        Mileage.SetRange("Register No.", "No.");
        PostedMileage.SetShowAllMileageIncludingSttl;
        PostedMileage.SetTableView(Mileage);
        PostedMileage.Run;
    end;


    procedure DrillDownReimbEntries()
    var
        Mileage: Record "CEM Mileage";
        PostedMileage: Page "CEM Posted Mileage";
    begin
        Mileage.SetCurrentKey("Reimbursement Register No.");
        Mileage.SetRange("Reimbursement Register No.", "No.");
        PostedMileage.SetShowAllMileageIncludingSttl;
        PostedMileage.SetTableView(Mileage);
        PostedMileage.Run;
    end;
}

