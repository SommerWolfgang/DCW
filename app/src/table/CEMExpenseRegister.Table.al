table 6086372 "CEM Expense Register"
{
    Caption = 'Expense Register';
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
        field(10; "No. of Expense Entries"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Register No." = field("No.")));
            Caption = 'No. of Expense Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownExpenseEntries();
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = count("CEM Expense" where("Reimbursement Register No." = field("No.")));
            Caption = 'No. of Reimbursed Expense Entries';
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

    procedure DrillDownExpenseEntries()
    begin
    end;

    procedure DrillDownReimbEntries()
    begin
    end;
}