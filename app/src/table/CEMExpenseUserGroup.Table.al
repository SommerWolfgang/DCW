table 6086302 "CEM Expense User Group"
{
    Caption = 'Expense User Group';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Mileage Reimbursement Method"; Option)
        {
            Caption = 'Mileage Reimbursement Method';
            Description = 'Obsolete';
            OptionCaption = ' ,Vendor (on User),External System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;
        }
        field(12; "Reimbursement Method"; Option)
        {
            Caption = 'Reimbursement Method';
            Description = 'Obsolete';
            OptionCaption = ' ,Vendor (on User),External System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;
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
        LookupValAccess: Record "CEM Lookup Value Access";
    begin
        LookupValAccess.SetRange(Type, LookupValAccess.Type::Group);
        LookupValAccess.SetRange(Code, Code);
        LookupValAccess.DeleteAll(true);
    end;

    trigger OnRename()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        ContiniaUserSetup.SetRange("Expense User Group", xRec.Code);
        ContiniaUserSetup.ModifyAll("Expense User Group", Code);
    end;


    procedure UpdateReimbursementMethod()
    begin
    end;


    procedure GetReimbursMethodForRecUsr(ContUserID: Code[50]): Integer
    begin
    end;
}

