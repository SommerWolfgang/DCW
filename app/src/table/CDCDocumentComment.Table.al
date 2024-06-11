table 6085594 "CDC Document Comment"
{
    Caption = 'Document Comment';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CDC Document";
        }
        field(3; "Template No."; Code[20])
        {
            Caption = 'Template No.';
        }
        field(4; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
            TableRelation = "CDC Template Field".Type where("Template No." = field("Template No."));
        }
        field(5; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            TableRelation = "CDC Template Field".Code where("Template No." = field("Template No."),
                                                             Type = field("Field Type"));
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Comment Type"; Option)
        {
            Caption = 'Comment Type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;
        }
        field(8; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(9; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Capture,Validation,Processing,Match,Import';
            OptionMembers = Capture,Validation,Processing,Match,Import;
        }
        field(10; "Message Center ID"; Code[50])
        {
            Caption = 'Message Center ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Comment Type")
        {
        }
    }

    fieldgroups
    {
    }

    procedure Add(Document: Record "CDC Document"; "Field": Record "CDC Template Field"; LineNo: Integer; "Area": Integer; CommentType: Integer; Comment: Text[250])
    var
        DocComment: Record "CDC Document Comment";
    begin
        DocComment."Document No." := Document."No.";
        DocComment."Template No." := Document."Template No.";
        DocComment."Field Type" := Field.Type;
        DocComment."Field Code" := Field.Code;
        DocComment."Line No." := LineNo;
        DocComment.Area := Area;
        DocComment."Comment Type" := CommentType;
        DocComment.Comment := Comment;
        DocComment.Insert(true);
    end;

    procedure AddMsgCenter(Document: Record "CDC Document"; "Field": Record "CDC Template Field"; LineNo: Integer; "Area": Integer; CommentType: Integer; Comment: Text[250]; MsgCenterID: Code[50]; InfoAllowed: Boolean; WarningAllowed: Boolean; ErrorAllowed: Boolean; var ErrorWasAdded: Boolean)
    begin
    end;
}