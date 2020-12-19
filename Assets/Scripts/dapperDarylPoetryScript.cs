using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class dapperDarylPoetryScript : MonoBehaviour
{
    [SerializeField, TextArea] string[] Lines;
    [SerializeField] Text myText;
    int lineNum = 0;
    public void nextLine()
    {
        lineNum++;
        if(lineNum > Lines.Length - 1)
        {
            lineNum = 0;
        }
        myText.text = Lines[lineNum];
    }
}
