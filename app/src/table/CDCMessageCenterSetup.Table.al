table 6086016 "CDC Message Center Setup"
{
    Caption = 'Message Center Setup';

    fields
    {
        field(1; "Message Center ID"; Code[50])
        {
            Caption = 'Message Center ID';
            NotBlank = true;
        }
        field(2; "Field Type"; Option)
        {
            Caption = 'Field Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
        }
        field(4; "Comment Type"; Option)
        {
            Caption = 'Comment Type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;
        }
        field(5; "Comment (Example)"; Text[250])
        {
            Caption = 'Comment (example)';
        }
        field(6; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Capture,Validation,Processing,Match,Import';
            OptionMembers = Capture,Validation,Processing,Match,Import;
        }
        field(7; "Information Allowed"; Boolean)
        {
            Caption = 'Information Allowed';
        }
        field(8; "Warning Allowed"; Boolean)
        {
            Caption = 'Warning Allowed';
        }
        field(9; "Error Allowed"; Boolean)
        {
            Caption = 'Error Allowed';
        }
        field(10; "User Defined Comment Type"; Option)
        {
            Caption = 'User Defined Comment Type';
            OptionCaption = 'Information,Warning,Error';
            OptionMembers = Information,Warning,Error;
        }
        field(11; "Create Delegate Comt. On Error"; Boolean)
        {
            Caption = 'Create Delegate Comment On Error';
        }
    }

    keys
    {
        key(Key1; "Message Center ID")
        {
            Clustered = true;
        }
    }
    procedure GetMsgCenterSetup(MsgCenterID: Code[50]; CommentType: Integer; InfoAllowed: Boolean; WarningAllowed: Boolean; ErrorAllowed: Boolean; Comment: Text[250]; TemplateNo: Code[20])
    begin
    end;
}