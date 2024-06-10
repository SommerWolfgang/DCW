table 6086371 "CEM Comment Line"
{
    Caption = 'Comment Line';

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Settlement';
            OptionMembers = "Expense Header";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name" = CONST("Expense Header")) "CEM Expense Header"."No." WHERE("Document Type" = CONST(Settlement));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetUpNewLine()
    var
        EMCommentLine: Record "CEM Comment Line";
    begin
        EMCommentLine.SetRange("Table Name", "Table Name");
        EMCommentLine.SetRange("No.", "No.");
        EMCommentLine.SetRange(Date, WorkDate);
        if EMCommentLine.IsEmpty then
            Date := WorkDate;
    end;
}

