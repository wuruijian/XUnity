using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XUnity.Jim;

public class Main : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        gameObject.transform.localPosition = new Vector3(0,0,0);
        bool isInit = GameUtil.isInit;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    /// <summary>
    /// This function is called when the object becomes enabled and active.
    /// </summary>
    void OnEnable()
    {
        
    }

    /// <summary>
    /// OnPreCull is called before a camera culls the scene.
    /// </summary>
    void OnPreCull()
    {
        
    }
}
