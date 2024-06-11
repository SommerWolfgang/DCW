table 6086367 "CEM Register"
{
    Caption = 'Register';
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
            CalcFormula = count("CEM Mileage" where("Register No." = field("No.")));
            Caption = 'No. of Mileage Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownMileageEntries();
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = count("CEM Mileage" where("Reimbursement Register No." = field("No.")));
            Caption = 'No. of Reimbursed Mileage Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownReimbEntries();
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

    procedure CreateRegEntry(): Integer
    begin
    end;


    procedure DrillDownMileageEntries()
    begin
    end;

    procedure DrillDownReimbEntries()
    begin
    end;
}