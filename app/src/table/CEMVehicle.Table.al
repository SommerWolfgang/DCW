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
            CalcFormula = count("CEM Company Policy" where("Document Type" = const(Expense),
                                                            "Document Account No." = field(Code)));
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

    procedure GetUserVehicle(User: Code[50]): Code[20]
    begin
    end;

    procedure HasBeenUsedWithinAYear(): Boolean
    begin
    end;
}