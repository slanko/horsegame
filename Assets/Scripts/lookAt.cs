using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lookAt : MonoBehaviour
{
    public GameObject lookTarget;
    [SerializeField] bool findPlayer = false;

    private void Start()
    {
        if(findPlayer == true)
        {
            lookTarget = GameObject.Find("Player");
        }
    }
    void Update()
    {
        transform.LookAt(lookTarget.transform.position);
    }
}
