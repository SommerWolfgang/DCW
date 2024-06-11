table 12032000 "DC - Setup"
{
    Caption = 'Document Configurator Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Copy Label Code"; Code[20])
        {
            Caption = 'Copy Label Code';
        }
        field(3; "Page Label Code"; Code[20])
        {
            Caption = 'Page Label Code';
        }
        field(4; "Font Family"; Text[30])
        {
            Caption = 'Font Family';
        }
        field(5; "Font Size"; Integer)
        {
            Caption = 'Font Size';
        }
        field(6; "Max Pages per Document"; Integer)
        {
            Caption = 'Max Pages per Document';
        }
        field(7; "Max Iterations per Section"; Integer)
        {
            Caption = 'Max Iterations per Section';
        }
        field(10; "Carry Over Label Code Header"; Code[20])
        {
            Caption = 'Carry Over Label Code Header';
        }
        field(11; "Carry Over Label Code Footer"; Code[20])
        {
            Caption = 'Carry Over Label Code Footer';
        }
        field(20; "Show Design Marks"; Boolean)
        {
            Caption = 'Show Design Marks';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}