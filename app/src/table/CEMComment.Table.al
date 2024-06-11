table 6086361 "CEM Comment"
{
    Caption = 'Comment';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
            TableRelation = IF ("Table ID" = CONST (6086320)) "CEM Expense"
            ELSE
            IF ("Table ID" = CONST (6086338)) "CEM Mileage";
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Importance; Option)
        {
            Caption = 'Importance';
            OptionCaption = 'Error,Warning,Information';
            OptionMembers = Error,Warning,Information;
        }
        field(11; "Area"; Code[20])
        {
            Caption = 'Code';
        }
        field(12; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(13; "Validation Comment"; Boolean)
        {
            Caption = 'Validation Comment';
        }
        field(14; "Created Date/Time"; DateTime)
        {
            Caption = 'Created Date Time';
        }
        field(15; "Created by"; Code[50])
        {
            Caption = 'Created by';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", Importance)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created Date/Time" := CurrentDateTime;
        "Created by" := UserId;
    end;
}

